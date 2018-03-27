defmodule DeditexBaseTest do
  alias Deditex.Base
  alias Deditex.Address
  use ExUnit.Case

  doctest Deditex.Base

  test "JobId Funktion Min", do: assert(Base.jobid(%{jobid: 0}) == 0)
  test "JobId Funktion Max", do: assert(Base.jobid(%{jobid: 255}) == 255)
  test "JobId Overflow", do: assert(Base.jobid(%{jobid: 256}) == 0)
end
