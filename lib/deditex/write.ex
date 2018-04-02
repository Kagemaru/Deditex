defmodule Deditex.Write do
  alias Deditex.Base
  alias Deditex.Helper

  @doc "Writes a <value> to <width> channels starting at <first_channel>."
  @spec write_to_deditec(String.t(), pos_integer(), non_neg_integer(), map()) :: :ok | :error
  def write_to_deditec(width, first_channel, value, state) do
    {job, package} = generate_write_package(width, first_channel, value, state)

    Map.fetch(state, :socket)
    |> Base.send_msg(package)
    |> Base.recv_msg()
    |> Base.handle_response(job, width)
  end

  @spec generate_write_package(<<_::8>>, non_neg_integer(), non_neg_integer(), map()) ::
          {byte(), binary()}
  def generate_write_package(width, address, data, state) do
    Helper.generate_package("W", width, address, data, state)
  end
end
