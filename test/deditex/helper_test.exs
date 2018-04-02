defmodule DeditexHelperTest do
  alias Deditex.Helper
  use ExUnit.Case

  doctest Deditex.Helper

  setup do
    exp_write = {
      {
        0,
        <<0x63, 0x9A, 0x01, 0x00, 0x00, 0x0B, 0x57, 0x42, 0x00, 0x00, 0x00>>
      },
      {
        0x55,
        <<0x63, 0x9A, 0x01, 0x55, 0x00, 0x0B, 0x57, 0x42, 0x00, 0x00, 0x00>>
      }
    }

    exp_read = {
      {
        0,
        <<99, 154, 1, 0, 0, 10, 82, 66, 0, 0>>
      },
      {
        0x55,
        <<99, 154, 1, 0x55, 0, 10, 82, 66, 0, 0>>
      }
    }

    [exp_write: exp_write, exp_read: exp_read]
  end

  test "package generation write", config do
    expected = elem(config[:exp_write], 0)
    assert ^expected = Helper.generate_package("W", "B", 0x00, 0x00, %{})
  end

  test "package generation write non-0 jobid", config do
    expected = elem(config[:exp_write], 1)
    assert ^expected = Helper.generate_package("W", "B", 0x00, 0x00, %{jobid: 0x55})
  end

  test "package generation read", config do
    expected = elem(config[:exp_read], 0)
    assert ^expected = Helper.generate_package("R", "B", 0x00, %{})
  end

  test "package generation read non-0 jobid", config do
    expected = elem(config[:exp_read], 1)
    assert ^expected = Helper.generate_package("R", "B", 0x00, %{jobid: 0x55})
  end
end
