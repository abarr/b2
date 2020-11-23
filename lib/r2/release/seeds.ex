defmodule B2.Release.Seeds do
  @app :b2

  def run(repo, filename) do
    load_app()

    case Ecto.Migrator.with_repo(repo, &eval_seed(&1, filename)) do
      {:ok, {:ok, _fun_return}, _apps} ->
        :ok

      {:ok, {:error, reason}, _apps} ->
        IO.warn(reason, [])
        {:error, reason}

      {:error, term} ->
        IO.warn(term, [])
        {:error, term}
    end
  end

  defp eval_seed(_repo, filename) do
    seeds_file = get_path("repo", filename)

    if File.regular?(seeds_file) do
      {:ok, Code.eval_file(seeds_file)}
    else
      {:error, "Seeds file not found."}
    end
  end

  defp get_path(directory, filename) do
    priv_dir = "#{:code.priv_dir(@app)}"
    Path.join([priv_dir, directory, filename])
  end

  defp load_app(), do: Application.load(@app)
end
