<?php
$host = "localhost";
$user = "root";
$pass = "root";
$db   = "agenda";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Erro de conexão: " . $conn->connect_error);
}

// Inserção de dados
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nome = $_POST["nome"];
    $telefone = $_POST["telefone"];

    // Validação do telefone (xx) x xxxx-xxxx
    if (preg_match("/^\(\d{2}\)\s\d\s\d{4}-\d{4}$/", $telefone)) {
        $stmt = $conn->prepare("INSERT INTO contatos (nome, telefone) VALUES (?, ?)");
        $stmt->bind_param("ss", $nome, $telefone);
        $stmt->execute();
        $stmt->close();
    } else {
        echo "<p style='color:red;'>Telefone inválido! Use o formato (xx) x xxxx-xxxx</p>";
    }
}

// Buscar dados
$result = $conn->query("SELECT * FROM contatos ORDER BY id DESC");
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Cadastro de Contatos</title>

<style>
body {
    font-family: Arial;
    margin: 20px;
}

table {
    border-collapse: collapse;
    width: 100%;
}

th {
    background-color: #333;
    color: white;
    padding: 10px;
}

td {
    padding: 8px;
    text-align: center;
}

/* Linhas alternadas */
tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:nth-child(odd) {
    background-color: #ffffff;
}

form {
    margin-bottom: 20px;
}
</style>

</head>
<body>

<h2>Cadastro de Contatos</h2>

<form method="POST">
    Nome: <input type="text" name="nome" required>
    Telefone: <input type="text" name="telefone" placeholder="(11) 9 1234-5678" required>
    <button type="submit">Cadastrar</button>
</form>

<h3>Lista de Contatos</h3>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>Telefone</th>
        <th>Data</th>
    </tr>

<?php
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>{$row['id']}</td>
                <td>{$row['nome']}</td>
                <td>{$row['telefone']}</td>
                <td>{$row['criado_em']}</td>
              </tr>";
    }
} else {
    echo "<tr><td colspan='4'>Nenhum registro encontrado</td></tr>";
}

$conn->close();
?>

</table>

</body>
</html>
Exibindo cadastro_contatos.php…