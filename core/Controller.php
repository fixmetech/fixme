<?php

namespace app\core;

class Controller
{

    public string $layout = 'main';

    public function setLayout($layout)
    {
        $this->layout = $layout;
    }

    // what $params is for is to pass data to the view
    public function render($view, $params = [])
    {
        return Application::$app->router->renderView($view, $params);
    }
}
