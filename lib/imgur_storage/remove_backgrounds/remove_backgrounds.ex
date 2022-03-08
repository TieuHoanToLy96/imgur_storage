defmodule RemoveBackgrounds do
  use Export.Python

  @python_dir "lib/imgur_storage/python"
  @python_module "remove_background"

  def python_call(file, function, args \\ []) do
    {:ok, py} = Python.start(python_path: Path.expand(@python_dir))
    Python.call(py, file, function, args)
  end

  def run_test() do
    python_call(@python_module, "remove", [])
  end
end
