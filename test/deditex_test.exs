defmodule DeditexTest do
  use ExUnit.Case, async: true

  doctest Deditex

  setup_all do
    ip = "192.168.0.254"
    t_ip = {192, 168, 0, 254}
    port = 9912
    [ip: ip, t_ip: t_ip, port: port]
  end

  describe "Considering starting a connection" do
    @tag timeout: 1000
    test "starting a Deditec connection", c do
      ip = c[:ip]
      t_ip = c[:t_ip]
      port = c[:port]
      {:ok, pid} = Deditex.start_link(ip, port)
      state = Deditex.read_all_from_state(pid)
      assert %{ip: ^t_ip, port: ^port} = state
    end

    @tag timeout: 1000
    test "starting a Deditec connection with default port", c do
      ip = c[:ip]
      t_ip = c[:t_ip]
      port = c[:port]
      {:ok, pid} = Deditex.start_link(ip)
      state = Deditex.read_all_from_state(pid)
      assert %{ip: ^t_ip, port: ^port} = state
    end
  end

  describe "Considering handling jobids" do
    setup c do
      {:ok, pid} = Deditex.start_link(c[:ip])
      [pid: pid]
    end

    test "getting first jobid", c do
      0 = Deditex.get_jobid(c[:pid])
    end

    test "getting another jobid", c do
      Deditex.add_to_state(c[:pid], :jobid, 255)
      assert 255 = Deditex.get_jobid(c[:pid])
    end

    test "getting resetted jobid", c do
      Deditex.add_to_state(c[:pid], :jobid, 256)
      assert 0 = Deditex.get_jobid(c[:pid])
    end
  end

  describe "Considering handling state" do
    setup c do
      {:ok, pid} = Deditex.start_link(c[:ip])
      [pid: pid]
    end

    test "Read state", c do
      Deditex.read_all_from_state(c[:pid])
    end

    test "Read item from state", c do
      t_ip = c[:t_ip]
      ip = Deditex.read_from_state(c[:pid], :ip)
      assert ^t_ip = ip
    end

    test "Add item to state", c do
      Deditex.add_to_state(c[:pid], :test, 1234)
      assert 1234 = Deditex.read_from_state(c[:pid], :test)
    end
  end
end
