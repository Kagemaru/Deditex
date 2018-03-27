defmodule DeditexTest do
  use ExUnit.Case

  doctest Deditex

  setup do
    ip = "192.168.0.254"
    t_ip = {192, 168, 0, 254}
    port = 9912
    [ip: ip, t_ip: t_ip, port: port]
  end

  @tag timeout: 1000
  test "starting a Deditec connection", config do
    ip = config[:ip]
    t_ip = config[:t_ip]
    port = config[:port]
    {:ok, d} = Deditex.start_link(ip, port)
    state = Deditex.read_all_from_state(d)
    assert %{ip: ^t_ip, port: ^port} = state
  end
end
