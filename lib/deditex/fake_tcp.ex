defmodule Deditex.FakeTCP do
  @moduledoc "Mock for Deditec communication."

  alias Deditex.Address
  alias Deditex.Helper

  require Deditex.Address
  require IEx

  @type ip4_address() :: {0..255, 0..255, 0..255, 0..255}
  @type ip6_address() ::
          {0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535}
  @type ip_address() :: ip4_address() | ip6_address()

  @spec connect(ip_address, non_neg_integer(), [...]) :: pid()
  def connect(_ip, _port, _opts), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @spec send(port(), binary()) :: :ok | :error
  def send(socket, package) do
    if byte_size(package) == 10 do
      read_from_state(socket, package)
    else
      # write_to_state(socket, 1, 11, "B", <<10, 10>>)
      write_to_state(socket, package)
    end

    # case package do
    #
    # 	_ -> :error
    # end
  end

  def recv(socket, _length), do: {:ok, Agent.get(socket, &Map.get(&1, :recv))}

  def read_from_state(socket, package) do
    <<Address.send_header(), job::8, _length::16, 0x52::8, width::8, address::16>> = package
    <<response>> = Agent.get(socket, &Map.get(&1, address))
    data_width = Helper.translate_width(<<width>>)
    length = calculate_length(data_width)

    data =
      case response do
        nil -> <<Address.response_header(), 0::8, job::8, length::16, 0::size(data_width)>>
        _ -> <<Address.response_header(), 0::8, job::8, length::16, response::size(data_width)>>
      end

    Agent.update(socket, &Map.put(&1, :recv, data))
    :ok
  end

  def write_to_state(socket, package) do
    <<Address.send_header(), job::8, _length::16, 0x57::8, width::8, address::16, data::binary>> =
      package

    data_width = Helper.translate_width(<<width>>)
    Agent.update(__MODULE__, &Map.put(&1, address, data))

    Agent.update(
      __MODULE__,
      &Map.put(&1, :recv, <<Address.response_header(), 0::8, job::8, 7::16>>)
    )

    :ok
  end

  defp calculate_length(data_width), do: 7 + div(data_width, 8)
end
