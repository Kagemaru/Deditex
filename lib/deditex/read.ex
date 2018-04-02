defmodule Deditex.Read do
  alias Deditex.Base
  alias Deditex.Helper

  @doc "Reads a value from multiple channels starting at first_channel."
  @spec read_from_deditec(String.t(), pos_integer(), map()) ::
          :error
          | :ok
          | {:error, byte()}
          | {:ok, non_neg_integer()}
          | {:error, byte(), non_neg_integer()}
  def read_from_deditec(width, first_channel, state) do
    {job, package} = generate_read_package(width, first_channel, state)

    Map.fetch(state, :socket)
    |> Base.send_msg(package)
    |> Base.recv_msg()
    |> Base.handle_response(job, width)
  end

  @spec generate_read_package(<<_::8>>, non_neg_integer(), map()) :: {byte(), binary()}
  def generate_read_package(width, address, state) do
    Helper.generate_package("R", width, address, state)
  end
end
