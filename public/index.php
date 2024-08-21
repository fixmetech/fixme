<?php

require_once __DIR__ . '/../vendor/autoload.php';

use app\core\Application;
use app\controllers\SiteController;

$app = new Application(dirname(__DIR__));

$app->router->get('/', [SiteController::class, 'home']);
$app->router->get('/customer-sign-up', [SiteController::class, 'customerSignUp']);
$app->router->get('/technician-sign-up', [SiteController::class, 'technicianSignUp']);

$app->run();









function show($data)
{
    echo '<pre>';
    print_r($data);
    echo '</pre>';
}
