defmodule FirstBench do
  use Benchfella
  alias Deditex

  before_each_bench _ do
    {:ok, d} = Deditex.start_link("192.168.0.254")
    opts = [:binary, active: false, reuseaddr: true]
    {:ok, g} = :gen_tcp.connect({192, 168, 0, 254}, 9912, opts)
    {:ok, {d, g}}
  end

  after_each_bench opts do
    g = elem(opts, 1)
    :gen_tcp.close(g)
  end

  bench "read over class" do
    d = elem(bench_context, 0)
    Deditex.read(d, "W", 0)
    :ok
  end

  bench "read directly" do
    g = elem(bench_context, 1)
    :gen_tcp.send(g, <<99, 154, 1, 0, 0, 10, 82, 66, 0, 0>>)
  end
end
