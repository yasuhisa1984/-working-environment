<?php

$finder = PhpCsFixer\Finder::create()->in(__DIR__)->exclude(['vendor']);

return (new PhpCsFixer\Config())
    ->setRules([
        // PSR系を外して純粋に braces を指定してもOK
        'braces' => [
            'position_after_functions_and_oop_constructs' => 'same',  // class / function
            'position_after_control_structures'           => 'same',  // if / for / while
            'position_after_anonymous_constructs'         => 'same',
        ],
    ])
    ->setFinder($finder);
