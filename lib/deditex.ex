defmodule Deditex do
  @moduledoc """
  Documentation for Deditec Communication Module.
  """

  @type ip4_address() :: {0..255, 0..255, 0..255, 0..255}
  @type ip6_address() ::
          {0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535}
  @type ip_address() :: ip4_address() | ip6_address()

  @deditex_api Application.get_env(:deditex, :deditex_api)

  alias Deditex.Base
  alias Deditex.Read
  alias Deditex.Write

  use GenServer

  # Client API
  @doc "Does the necessary setup for communication."
  def start_link(ip, port \\ 9912)

  @spec start_link(String.t(), non_neg_integer()) :: pid()
  def start_link(ip, port) when is_bitstring(ip) do
    with c_ip <- String.to_charlist(ip),
         {:ok, t_ip} <- :inet_parse.address(c_ip),
         do: start_link(t_ip, port)
  end

  @spec start_link(ip_address(), non_neg_integer()) :: {:ok, pid()}
  def start_link(ip, port) when is_tuple(ip), do: GenServer.start_link(__MODULE__, {ip, port}, [])

  @spec get_jobid(pid()) :: non_neg_integer()
  def get_jobid(pid), do: GenServer.call(pid, {:get_jobid})

  @spec read(pid(), String.t(), pos_integer()) :: non_neg_integer()
  def read(pid, width, first_channel), do: GenServer.call(pid, {:read, width, first_channel})

  @spec write(pid(), String.t(), pos_integer(), pos_integer()) :: no_return()
  def write(pid, width, first_channel, value),
    do: GenServer.call(pid, {:write, width, first_channel, value})

  @spec read_all_from_state(pid()) :: map()
  def read_all_from_state(pid), do: GenServer.call(pid, {:read_all_from_state})

  @spec read_from_state(pid(), any()) :: any()
  def read_from_state(pid, key), do: GenServer.call(pid, {:read_from_state, key})

  @spec add_to_state(pid(), any(), any()) :: none()
  def add_to_state(pid, key, value), do: GenServer.cast(pid, {:add_to_state, key, value})
  # End of Client API

  # Server Callbacks
  @spec init({ip_address(), non_neg_integer()}) :: {:ok, map()}
  def init({ip, port}) do
    {:ok, socket} = @deditex_api.connect(ip, port, [:binary, active: false, reuseaddr: true])
    {:ok, %{ip: ip, port: port, socket: socket}}
  end

  @spec handle_call({:get_jobid}, any(), map()) :: {:reply, non_neg_integer, map()}
  def handle_call({:get_jobid}, _from, state), do: {:reply, Base.jobid(state), state}

  @spec handle_call({:read, String.t(), non_neg_integer()}, any(), map()) ::
          {:reply, non_neg_integer(), map()}
  def handle_call({:read, width, first_channel}, _from, state) do
    {:ok, value} = Read.read_from_deditec(width, first_channel, state)
    {:reply, value, Map.put(state, :jobid, Base.jobid(state) + 1)}
  end

  # TODO: Maybe change to handle_cast?
  @spec handle_call({:write, String.t(), non_neg_integer(), non_neg_integer()}, any(), map()) ::
          {:reply, :ok, map()}
  def handle_call({:write, width, first_channel, value}, _from, state) do
    Write.write_to_deditec(width, first_channel, value, state)
    {:reply, :ok, Map.put(state, :jobid, Base.jobid(state) + 1)}
  end

  @spec handle_call({:read_all_from_state}, any(), map()) :: {:reply, map(), map()}
  def handle_call({:read_all_from_state}, _from, state), do: {:reply, state, state}

  @spec handle_call({:read_from_state, any()}, any(), map()) :: {:reply, any(), map()}
  def handle_call({:read_from_state, key}, _from, state), do: {:reply, state[key], state}

  @spec handle_cast({:add_to_state, any(), any()}, map()) :: {:noreply, map()}
  def handle_cast({:add_to_state, key, value}, state), do: {:noreply, Map.put(state, key, value)}
end
