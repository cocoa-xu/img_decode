defmodule StbImage.Nif do
  @moduledoc false

  @on_load :load_nif
  def load_nif do
    nif_file = '#{:code.priv_dir(:stb_image)}/stb_image_nif'

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> IO.puts("Failed to load nif: #{reason}")
    end
  end

  def from_file(_path, _desired_channels, _type), do: :erlang.nif_error(:not_loaded)
  def from_binary(_buffer, _desired_channels, _type), do: :erlang.nif_error(:not_loaded)
  def gif_from_binary(_gif_path), do: :erlang.nif_error(:not_loaded)

  def to_file(_path, _extension, _data, _width, _height, _channels),
    do: :erlang.nif_error(:not_loaded)

  def to_binary(_extension, _data, _width, _height, _channels), do: :erlang.nif_error(:not_loaded)
end
