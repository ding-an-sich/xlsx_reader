defmodule XlsxReader.UnzipTest do
  use ExUnit.Case

  alias XlsxReader.Unzip

  describe "list/1" do
    test "lists the contents of a zip file" do
      zip_handle = {:path, TestFixtures.path("test.zip")}

      assert {:ok, ["dir/subdir/file3.bin", "file1.txt", "file2.dat"]} = Unzip.list(zip_handle)
    end

    test "lists the contents of a zip buffer" do
      zip_handle = {:binary, TestFixtures.read!("test.zip")}

      assert {:ok, ["dir/subdir/file3.bin", "file1.txt", "file2.dat"]} = Unzip.list(zip_handle)
    end

    test "invalid zip file" do
      assert {:error, :einval} = Unzip.list({:path, TestFixtures.path("not_a_zip.zip")})
    end
  end

  describe "extract/2" do
    test "extracts a file from a zip file" do
      zip_handle = {:path, TestFixtures.path("test.zip")}

      assert {:ok, "Contents of file1\n"} = Unzip.extract(zip_handle, "file1.txt")
      assert {:ok, "Contents of file2\n"} = Unzip.extract(zip_handle, "file2.dat")
      assert {:ok, "Contents of file3\n"} = Unzip.extract(zip_handle, "dir/subdir/file3.bin")

      assert {:error, "file \"bogus.bin\" not found"} = Unzip.extract(zip_handle, "bogus.bin")
    end

    test "extracts a file from zip buffer" do
      zip_handle = {:path, TestFixtures.path("test.zip")}

      assert {:ok, "Contents of file1\n"} = Unzip.extract(zip_handle, "file1.txt")
      assert {:ok, "Contents of file2\n"} = Unzip.extract(zip_handle, "file2.dat")
      assert {:ok, "Contents of file3\n"} = Unzip.extract(zip_handle, "dir/subdir/file3.bin")

      assert {:error, "file \"bogus.bin\" not found"} = Unzip.extract(zip_handle, "bogus.bin")
    end

    test "invalid zip file" do
      zip_handle = {:path, TestFixtures.path("not_a_zip.zip")}
      assert {:error, :einval} = Unzip.extract(zip_handle, "file1.txt")
    end
  end
end
