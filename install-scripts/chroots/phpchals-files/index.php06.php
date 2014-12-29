<?php
    $shortName = '06';
    $num = '0x06';
    $error = Null;

    $a = (isset($_GET['a']) ? (int)$_GET['a'] : Null);
    $b = (isset($_GET['b']) ? (int)$_GET['b'] : Null);
    $c = (isset($_GET['c']) ? $_GET['c'] : Null);
    $d = (isset($_GET['d']) ? $_GET['d'] : Null);

    //step 1
    if(!($a === $b || $a === $c || $a === $d || $b === $c || $b === $d || $c === $d)){
        echo "ok 1\n";
        // step 2
        if($b === 0144 && $a == $c){
            echo "ok 2\n";
            // Step 3
            if ($a == $d && $d < -1 && $a >= 0){
                echo "ok 3\n";
                //Step 4 
                $e = $a.$b;
                $f = $c.$b;
                if ((string)$e == (string)$f && (int)$e === (int)$f && strlen($e) === strlen($f)){
                    echo "ok 4\n";
                    $fp = fopen('/flag.txt','r');
                    echo fread($fp,64); 
                }
            }
        }
    }

?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hackfest 2014 - PHP Challenges</title>

    <!-- Bootstrap -->
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">

    <!-- HF CSS -->
    <link href="/static/css/web.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <div class="site-wrapper">

      <div class="site-wrapper-inner">

        <div class="cover-container">

          <div class="masthead clearfix">
            <div class="inner">
              <h3 class="masthead-brand">PHP Challenges</h3>
              <ul class="nav masthead-nav">
                <li <?php echo ($shortName == '01' ? 'class="active"' : '') ?>><a href="/01/">0x01</a></li>
                <li <?php echo ($shortName == '02' ? 'class="active"' : '') ?>><a href="/02/">0x02</a></li>
                <li <?php echo ($shortName == '03' ? 'class="active"' : '') ?>><a href="/03/">0x03</a></li>
                <li <?php echo ($shortName == '04' ? 'class="active"' : '') ?>><a href="/04/">0x04</a></li>
                <li <?php echo ($shortName == '05' ? 'class="active"' : '') ?>><a href="/05/">0x05</a></li>
                <li <?php echo ($shortName == '06' ? 'class="active"' : '') ?>><a href="/06/">0x06</a></li>
              </ul>
            </div>
          </div>

          <div class="inner cover">
            <h1 class="cover-heading">Challenge <?php echo $num; ?></h1>
            <p class="lead">Hard: PHP Brainfuck++.</p>
            <p>Hack this php-fpm chroot running <a href="/static/php06.txt">this code</a>.</p>

            <form class="form-signin" role="form" method="GET" action="/<?php echo $shortName; ?>/index.php">
                <input type="hidden" name="a" value=""/>
                <input type="hidden" name="b" value=""/>
                <input type="hidden" name="c" value=""/>
                <input type="hidden" name="d" value=""/>
                <?php
                    if($error){
                        echo '
                <div class="alert alert-danger" role="alert">
                    <strong>Oops!</strong> '.$error['message'].' on file '.$error['file'].' at line '.$error['line'].'
                </div>
                ';
                    }
                ?>
              <button class="btn btn-lg btn-default btn-block" type="submit">Exploit</button>
            </form>
          </div>

          <div class="mastfoot">
            <div class="inner">
              <p>&copy; Hackfest 2014</p>
            </div>
          </div>

        </div>

      </div>

    </div>
  </body>
</html>


