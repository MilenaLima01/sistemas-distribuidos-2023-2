defmodule Sistematask do
  @menu %{}

  def start do
    display_menu(@menu)
  end

  defp display_menu(menu) do
    IO.puts """
    Menu CRUD:

    1. Criar
    2. Ler
    3. Atualizar
    4. Excluir
    5. Sair
    """

    handle_input(menu)
  end

  defp handle_input(menu) do
    IO.write("Escolha uma opção: ")
    input = IO.gets("") |> String.trim()

    case input do
      "1" -> cadastrar(menu)
      "2" -> listar(menu)
      "3" -> alterar(menu)
      "4" -> deletar(menu)
      "5" -> sair_sistema()
      _   -> opcao_invalida(menu)
    end
  end

  defp cadastrar(menu) do
    IO.puts("Digite um nome para criar:")
    nome = IO.gets("") |> String.trim()

    task = Task.async(fn ->
      # Adiciona o nome ao mapa
      updated_menu = Map.put(menu, nome, true)
      IO.puts("Nome criado com sucesso: #{nome}")
      { :ok, updated_menu }
    end)

    { :ok, updated_menu } = Task.await(task)
    display_menu(updated_menu)
  end

  defp listar(menu) do
    task = Task.async(fn ->
      # Lógica de leitura aqui
      nomes = Map.keys(menu)
      IO.puts("Nomes armazenados: #{Enum.join(nomes, ", ")}")
      { :ok, menu }
    end)

    { :ok, updated_menu } = Task.await(task)
    display_menu(updated_menu)
  end

  defp alterar(menu) do
    IO.puts("Digite um nome para atualizar:")
    nome_antigo = IO.gets("") |> String.trim()

    case Map.get(menu, nome_antigo) do
      nil ->
        IO.puts("Nome não encontrado. Tente novamente.")
        display_menu(menu)
      _ ->
        IO.puts("Digite o novo nome:")
        novo_nome = IO.gets("") |> String.trim()

        task = Task.async(fn ->
          # Lógica de atualização aqui
          updated_menu = Map.delete(menu, nome_antigo)
          updated_menu = Map.put(updated_menu, novo_nome, true)
          IO.puts("Nome atualizado com sucesso: #{novo_nome}")
          { :ok, updated_menu }
        end)

        { :ok, updated_menu } = Task.await(task)
        display_menu(updated_menu)
    end
  end

  defp deletar(menu) do
    IO.puts("Digite um nome para excluir:")
    nome = IO.gets("") |> String.trim()

    case Map.get(menu, nome) do
      nil ->
        IO.puts("Nome não encontrado. Tente novamente.")
        display_menu(menu)
      _ ->
        task = Task.async(fn ->
          # Lógica de exclusão aqui
          updated_menu = Map.delete(menu, nome)
          IO.puts("Nome excluído com sucesso: #{nome}")
          { :ok, updated_menu }
        end)

        { :ok, updated_menu } = Task.await(task)
        display_menu(updated_menu)
    end
  end

  defp sair_sistema do
    IO.puts("Saindo do programa. Adeus!")
    System.halt(0)
  end

  defp opcao_invalida(menu) do
    IO.puts("Opção inválida. Tente novamente.")
    display_menu(menu)
  end
end
