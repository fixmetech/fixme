<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Sign Up</title>
    <link rel="stylesheet" href="/css/customer/customer-sign-up.css">
    <link rel="stylesheet" href="/css/base/_reset.css">
    <link rel="stylesheet" href="/css/base/_global.css">
</head>

<body>
    <div class="container">
        <div class="box-1">
        </div>
        <div class="box-2">
            <div class="wrapper">
                <div class="title-1">
                    <h2>Create an account</h2>
                    <h5>Already have an account? <a href="#">Login</a></h5>
                </div>
                <form action="customer-signup.php" method="post" class="cust-signup-form">
                    <div class="input-element">
                        <label for="user-name">User name</label>
                        <input type="text" name="user-name" id="user-name" required>
                    </div>
                    <div class="input-element">
                        <label for="email">Email address</label>
                        <input type="email" name="email" id="email" required>
                    </div>
                    <div class="input-element">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" required>
                        <h6>Use 8 or more characters with a mix of letters, numbers & symbols</h6>
                    </div>
                    <div class="terms-cond">
                        <input type="checkbox" name="terms-cond" id="terms-cond" required>
                        <label for="terms-cond">I agree to the terms and conditions</label>
                    </div>
                    <div class="not-robot">
                        <input type="checkbox" name="not-robot" id="not-robot" required>
                        <label for="not-robot">I'm not a robot</label>
                    </div>
                    <div>
                        <button type="submit" class="btn">Create an account</button>
                    </div>
                    <div class="log-in">
                        <h6>Already have an account? <a href="#">Log in</a></h6>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>