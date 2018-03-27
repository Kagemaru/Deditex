defmodule Deditex.Base do
  @deditex_api Application.get_env(:deditex, :deditex_api)

  require Deditex.Address
  alias Deditex.Address
  alias Deditex.Helper

  @spec jobid(map()) :: non_neg_integer()
  def jobid(state) do
    case state[:jobid] do
      x when x > 255 -> 0
      x when is_number(x) -> x
      _ -> 0
    end
  end

  @spec send_msg(port(), binary()) :: port()
  def send_msg({:ok, socket}, package) do
    :ok = @deditex_api.send(socket, package)
    socket
  end

  @spec recv_msg(port(), non_neg_integer()) :: {:ok, binary()} | {:error, any()}
  def recv_msg(socket, length \\ 0), do: @deditex_api.recv(socket, length)

  @spec handle_response(<<_::8>>, non_neg_integer(), String.t()) ::
          :ok | {:ok, binary()} | {:error, binary(), binary()} | {:error, binary()} | :error
  def handle_response({:ok, package}, job, width) do
    if byte_size(package) == 7 do
      handle_send_response(job, package)
    else
      handle_recv_response(job, width, package)
    end
  end

  @spec handle_send_response(non_neg_integer(), <<_::8>>) :: :ok | {:error, binary()} | :error
  def handle_send_response(job, package) do
    case package do
      <<Address.response_header(), 0::8, ^job::8, _length::16>> -> :ok
      <<Address.response_header(), code::8, ^job::8, _length::16>> -> {:error, code}
    end
  end

  @spec handle_recv_response(non_neg_integer(), String.t(), <<_::8>>) ::
          {:ok, binary()} | {:error, binary(), binary()} | :error
  def handle_recv_response(job, width, package) do
    data_width = Helper.translate_width(width)

    case package do
      <<Address.response_header(), 0::8, ^job::8, _length::16, data::size(data_width)>> ->
        {:ok, data}

      <<Address.response_header(), code::8, ^job::8, _length::16, data::size(data_width)>> ->
        {:error, code, data}
    end
  end
end
