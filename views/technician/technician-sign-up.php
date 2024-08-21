<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Sign Up</title>
    <link rel="stylesheet" href="/css/technician/technician-sign-up.css">
    <link rel="stylesheet" href="/css/base/_reset.css">
    <link rel="stylesheet" href="/css/base/_global.css">
</head>

<body>
    <div class="container">
        <div class="box-1">
            <div class="branding">
                <div>
                    <a href="/" class="brand-name">
                        <span class="brand-button">FixMe</span>
                    </a>
                </div>
                <p class="tagline">Expert Car Care, Anytime, Anywhere.</p>
            </div>
        </div>
        <div class="box-2">
            <div class="wrapper">
                <div class="title-1">
                    <h2>Become a Registered Technician</h2>
                </div>
                <form action="technician-signup.php" method="post" class="cust-signup-form">
                    <div class="input-element">
                        <label for="user-name">User name</label>
                        <input type="text" name="user-name" placeholder="Username..." id="user-name" required>
                    </div>
                    <div class="input-element">
                        <label for="nic">NIC No: </label>
                        <input type="text" name="nic" placeholder="NIC No..." id="nic" required>
                    </div>
                    <div class="input-element">
                        <label for="email">Email address</label>
                        <input type="email" name="email" id="email" placeholder="example@email.com..." required>
                    </div>
                    <div class="input-element">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" placeholder="Password..." required>
                    </div>
                    <h6>Use 8 or more characters with a mix of letters, numbers & symbols</h6>

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