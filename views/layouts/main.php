<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/base/_reset.css">
    <link rel="stylesheet" href="/css/base/_global.css">
    <link rel="stylesheet" href="/css/home/navbar.css">
    <link rel="stylesheet" href="/css/home/footer.css">
    <link rel="stylesheet" href="/css/home/home.css">
    <script src="/js/home/main.js"></script>
    <title>Fixme Home</title>
</head>

<body>
    <nav class="container">
        <header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3">
            <div class="col-md-3 mb-2 mb-md-0">
                <a href="/" class="d-inline-flex link-body-emphasis text-decoration-none">
                    <svg class="bi" width="40" height="32" role="img" aria-label="fixme">
                        <use xlink:href="#bootstrap"></use>
                    </svg>
                </a>
            </div>

            <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0">
                <li><a href="#" class="nav-link px-2 link-secondary">Home</a></li>
                <li><a href="#" class="nav-link px-2">Features</a></li>
                <li><a href="#" class="nav-link px-2">Map</a></li>
                <li><a href="#" class="nav-link px-2">FAQs</a></li>
                <li><a href="#" class="nav-link px-2">About</a></li>
            </ul>

            <div class="col-md-3 text-center">
                <button type="button" class="btn btn-outline-primary me-2"><a class="text-decoration-none" href="#">Login</a></button>
                <button type="button" class="btn btn-primary"><a class="text-decoration-none" href="/customer-sign-up">Sign Up</a></button>
            </div>
        </header>
    </nav>
    <div class="wrapper">
        {{content}}
    </div>
    <div class="container-f">
        <footer class="py-5">
            <div class="row">
                <div class="col-6 col-md-2 mb-3">
                    <h3 class="ml-3">FIXME</h3>
                </div>
                <div class="col-6 col-md-2 mb-3">
                    <h5>Company</h5>
                    <ul class="nav-f flex-column">
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">About Us</a></li>
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Our Offerings</a></li>
                    </ul>
                </div>

                <div class="col-6 col-md-2 mb-3">
                    <h5>Products</h5>
                    <ul class="nav flex-column">
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Nearby Technicians</a></li>
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Service Centers</a></li>
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Service Center Marketplace</a></li>
                    </ul>
                </div>

                <div class="col-6 col-md-2 mb-3">
                    <h5>Safety Measures</h5>
                    <ul class="nav flex-column">
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Safety</a></li>
                        <li class="nav-item-f mb-2"><a href="#" class="nav-link-f p-0 text-body-secondary">Diversity and Inclusion</a></li>
                    </ul>
                </div>

            </div>

            <div class="d-flex flex-column flex-sm-row justify-content-between py-4 my-4 mx-4 border-top">
                <p>© 2024 Fixme Technologies Inc.</p>
                <ul class="list-unstyled d-flex">
                    <li class="ms-3"><a class="link-body-emphasis" href="#"><svg class="bi" width="24" height="24">
                                <path d="M5.026 15c6.038 0 9.341-5.003 9.341-9.334 0-.14 0-.284-.009-.425A6.683 6.683 0 0 0 16 3.542a6.658 6.658 0 0 1-1.889.518A3.301 3.301 0 0 0 15.555 2a6.533 6.533 0 0 1-2.084.797 3.301 3.301 0 0 0-5.617 3.005A9.355 9.355 0 0 1 1.114 2.1a3.3 3.3 0 0 0 1.019 4.396A3.267 3.267 0 0 1 .64 6.575v.034a3.301 3.301 0 0 0 2.644 3.234 3.203 3.203 0 0 1-.865.115 3.23 3.23 0 0 1-.621-.059 3.305 3.305 0 0 0 3.067 2.281A6.588 6.588 0 0 1 0 13.027 9.286 9.286 0 0 0 5.031 15z" />
                                <use xlink:href="#twitter"></use>
                            </svg></a></li>
                    <li class="ms-3"><a class="link-body-emphasis" href="#"><svg class="bi" width="24" height="24">
                                <path d="M8 0C5.79 0 5.555.01 4.69.047a6.153 6.153 0 0 0-2.292.431 4.383 4.383 0 0 0-1.633 1.064A4.394 4.394 0 0 0 .048 4.69 6.154 6.154 0 0 0 0 6.977C0 7.445.002 7.805.005 8.128L.02 9.81v1.154c.003.352.006.729.006 1.104 0 .375-.003.752-.006 1.104v1.154c-.003.326-.005.687-.005 1.155 0 .642.027 1.192.125 1.684.099.492.264.939.518 1.33.22.333.514.616.87.857.33.226.706.41 1.12.556.466.166 1.065.239 1.747.263C5.805 16 6.287 16 8 16c1.713 0 2.195-.002 2.74-.014.682-.024 1.28-.097 1.746-.263a4.432 4.432 0 0 0 1.12-.556c.357-.241.65-.524.87-.857.253-.391.419-.838.518-1.33.098-.492.125-1.042.125-1.684 0-.469-.002-.83-.005-1.155v-1.154c-.003-.352-.006-.729-.006-1.104 0-.375.003-.752.006-1.104V9.81l.015-1.683c.003-.326.005-.687.005-1.155 0-.642-.027-1.192-.125-1.684a4.406 4.406 0 0 0-.518-1.33c-.22-.333-.514-.616-.87-.857a4.438 4.438 0 0 0-1.12-.556 6.163 6.163 0 0 0-1.746-.263C10.195.003 9.713.001 8 .001zm0 1.557c1.65 0 1.914.007 2.586.036.589.026 1.021.102 1.344.231.408.17.706.375.956.624.249.249.453.548.624.956.129.323.205.755.231 1.344.03.672.037.936.037 2.586 0 1.65-.007 1.914-.036 2.586-.026.589-.102 1.021-.231 1.344a2.764 2.764 0 0 1-.624.956 2.784 2.784 0 0 1-.956.624c-.323.129-.755.205-1.344.231-.672.03-.936.037-2.586.037-1.65 0-1.914-.007-2.586-.036-.589-.026-1.021-.102-1.344-.231a2.77 2.77 0 0 1-.956-.624 2.786 2.786 0 0 1-.624-.956c-.129-.323-.205-.755-.231-1.344-.03-.672-.037-.936-.037-2.586 0-1.65.007-1.914.036-2.586.026-.589.102-1.021.231-1.344.17-.408.375-.706.624-.956.249-.249.548-.453.956-.624.323-.129.755-.205 1.344-.231.672-.03.936-.037 2.586-.037zM8 3.292a4.706 4.706 0 1 0 0 9.411 4.706 4.706 0 0 0 0-9.411zm0 1.55a3.156 3.156 0 1 1 0 6.311 3.156 3.156 0 0 1 0-6.311zm4.566-.855a1.088 1.088 0 1 0 0 2.176 1.088 1.088 0 0 0 0-2.176z" />
                                <use xlink:href="#instagram"></use>
                            </svg></a></li>
                    <li class="ms-3"><a class="link-body-emphasis" href="#"><svg class="bi" width="24" height="24">
                                <path d="M8 0C3.582 0 0 3.582 0 8c0 4.07 3.065 7.428 7.032 7.931V10.14H5.037V8h1.995V6.392c0-1.973 1.21-3.05 2.963-3.05.84 0 1.562.063 1.77.09v2.053h-1.215c-.952 0-1.137.451-1.137 1.113V8h2.273l-.296 2.14H9.413v5.79C13.35 15.428 16 12.07 16 8c0-4.418-3.582-8-8-8z" />
                                <use xlink:href="#facebook"></use>
                            </svg></a></li>
                </ul>
            </div>
        </footer>
    </div>
</body>

</html>