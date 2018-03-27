defmodule DeditexReadTest do
  alias Deditex.Read
  use ExUnit.Case

  doctest Deditex.Read

  setup do
    ip = "192.168.0.254"
    t_ip = {192, 168, 0, 254}
    port = 9912
    [ip: ip, t_ip: t_ip, port: port]
  end

  test "read test value from deditec", config do
    value = :rand.uniform(0x100) - 1
    {:ok, d} = Deditex.start_link(config[:ip], config[:port])
    :ok = Deditex.write(d, "B", 0x00, value)
    assert value = Deditex.read(d, "B", 0x00)
  end
end
