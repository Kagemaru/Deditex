defmodule SecondBench do
  use Benchfella
  alias Deditex

  before_each_bench _ do
    opts = [:binary, active: false, reuseaddr: true]
    {:ok, g} = :gen_tcp.connect({192, 168, 0, 254}, 9912, opts)
  end

  after_each_bench g do
    :gen_tcp.close(g)
  end

  bench "read directly" do
    g = bench_context
    :gen_tcp.send(g, <<99, 154, 1, 0, 0, 10, 82, 66, 0, 0>>)
    :gen_tcp.recv(g, 0)
  end
end
