<?php

namespace app\controllers;

use app\core\Controller;

class SiteController extends Controller
{

    public function home()
    {
        $params = [
            'name' => 'Fixme'
        ];
        return $this->render('home', $params);
    }
}
