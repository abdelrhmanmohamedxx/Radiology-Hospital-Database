<?php if(!isset($page_title)) $page_title='Radiology HIS'; ?>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?php echo esc($page_title); ?></title><link rel="stylesheet" href="assets/style.css"></head><body>
<nav class="navbar"><a class="brand" href="index.php">Radiology HIS</a><div>
<a href="index.php">Home</a>
<?php if(isset($_SESSION['user_id'])): ?>
<a href="<?php echo strtolower($_SESSION['role']); ?>_dashboard.php">Dashboard</a><a href="logout.php">Logout</a>
<?php else: ?><a href="login.php">Login</a><a href="register.php">Register</a><?php endif; ?>
</div></nav><main class="container">