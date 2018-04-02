defmodule DeditexWriteTest do
  alias Deditex.Write
  use ExUnit.Case

  doctest Deditex.Write

  setup do
    ip = "192.168.0.254"
    t_ip = {192, 168, 0, 254}
    port = 9912
    [ip: ip, t_ip: t_ip, port: port]
  end

  test "write test value to deditec", config do
    value = :rand.uniform(0x100) - 1
    {:ok, d} = Deditex.start_link(config[:ip], config[:port])
    assert :ok = Deditex.write(d, "B", 0x00, value)
  end
end
