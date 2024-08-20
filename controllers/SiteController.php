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
        $this->setLayout('main');
        return $this->render('home', $params);
    }
    public function customerSignUp()
    {
        $this->setLayout('signup-login');
        return $this->render('customer-sign-up');
    }
}
