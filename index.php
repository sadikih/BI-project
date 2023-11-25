<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diabetes Prediction Form</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .container {
            text-align: center;
        }

        form {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: inline-block;
            text-align: left;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        input[type="submit"] {
            background-color: #4caf50;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .result-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: left;
            display: inline-block;
            margin-top: 20px; /* Adjust the margin to separate the form and results */
        }

        .result-item {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="container">

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Process the form data
        $arg_pregnant = $_POST['arg_pregnant'];
        $arg_glucose = $_POST['arg_glucose'];
        $arg_pressure = $_POST['arg_pressure'];
        $arg_triceps = $_POST['arg_triceps'];
        $arg_insulin = $_POST['arg_insulin'];
        $arg_mass = $_POST['arg_mass'];
        $arg_pedigree = $_POST['arg_pedigree'];
        $arg_age = $_POST['arg_age'];

        // Set the API endpoint URL with the updated port
        $apiUrl = 'http://127.0.0.1:9755/diabetes';

        // Initiate a new cURL session/resource
        $curl = curl_init();

        // Set the values of the parameters to pass to the model
        $params = array(
            'arg_pregnant' => $arg_pregnant,
            'arg_glucose' => $arg_glucose,
            'arg_pressure' => $arg_pressure,
            'arg_triceps' => $arg_triceps,
            'arg_insulin' => $arg_insulin,
            'arg_mass' => $arg_mass,
            'arg_pedigree' => $arg_pedigree,
            'arg_age' => $arg_age
        );

        // Set the cURL options
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_URL, $apiUrl . '?' . http_build_query($params));

        // For testing:
        echo "The generated URL sent to the API is:<br>" . $apiUrl . '?' . http_build_query($params) . "<br><br>";

        // Make a GET request
        $response = curl_exec($curl);

        // Check for cURL errors
        if (curl_errno($curl)) {
            $error = curl_error($curl);
            // Handle the error appropriately
            die("cURL Error: $error");
        }

        // Close cURL session/resource
        curl_close($curl);

        // Process the response
        $data = json_decode($response, true);

        // Check if the response was successful
        if (isset($data[0])) {
            // API request was successful
            echo "<div class='result-container'>";
            echo "<h2>The predicted diabetes status is:</h2>";

            // Process the data
            foreach ($data as $repository) {
                echo "<div class='result-item'>";
                echo $repository[0] . $repository[1] . $repository[2] . "<br>";
                echo "</div>";
            }

            echo "</div>";
        } else {
            // API request failed or returned an error
            // Handle the error appropriately
            echo "API Error: " . $data['message'];
        }
    }
    ?>

    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
        <!-- Add more input fields as needed -->
        <h2>Diabetes Prediction Form</h2>

        <label for="arg_pregnant">Pregnant:</label>
        <input type="number" name="arg_pregnant" required><br>

        <label for="arg_glucose">Glucose:</label>
        <input type="number" name="arg_glucose" required><br>

        <label for="arg_pressure">Pressure:</label>
        <input type="number" name="arg_pressure" required><br>

        <label for="arg_triceps">Triceps:</label>
        <input type="number" name="arg_triceps" required><br>

        <label for="arg_insulin">Insulin:</label>
        <input type="number" name="arg_insulin" required><br>

        <label for="arg_mass">Mass:</label>
        <input type="number" name="arg_mass" required><br>

        <label for="arg_pedigree">Pedigree:</label>
        <input type="number" name="arg_pedigree" step="0.001" required><br>

        <label for="arg_age">Age:</label>
        <input type="number" name="arg_age" required><br>

        <input type="submit" value="Predict">
    </form>

</div>

</body>
</html>
