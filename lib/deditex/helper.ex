defmodule Deditex.Helper do
  alias Deditex.Base
  alias Deditex.Address

  require Deditex.Address

  @spec generate_package(<<_::8>>, <<_::8>>, non_neg_integer(), integer(), map()) ::
          {byte(), binary()}
  def generate_package(cmd, width, address, data, state) do
    data_width = translate_width(width)
    {job, package} = generate_package(cmd, width, address, state)
    {job, package <> <<data::size(data_width)>>}
  end

  @spec generate_package(<<_::8>>, <<_::8>>, non_neg_integer(), map()) :: {byte(), binary()}
  def generate_package(cmd, width, address, state) do
    job = Base.jobid(state)

    package =
      Address.send_header() <>
        <<job::8, calculate_length(cmd, width)::16>> <> cmd <> width <> <<address::16>>

    {job, package}
  end

  @spec calculate_length(String.t(), binary()) :: non_neg_integer()
  def calculate_length(cmd, width) do
    case cmd do
      "W" -> 10 + div(translate_width(width), 8)
      "R" -> 10
    end
  end

  @spec translate_width(String.t()) :: non_neg_integer()
  def translate_width(width) do
    case width do
      "B" -> 8
      "W" -> 16
      "L" -> 32
      "X" -> 64
    end
  end
end
