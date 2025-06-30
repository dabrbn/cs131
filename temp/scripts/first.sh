#!/bin/bash

title="System Info Report for $HOSTNAME"
datestamp=$(date)
timestamp=$(date | cut -d" " -f4)

report_disk_space () {
	cat << EOF
	<h2>Disk Space</h2>
	<pre>$(df -h)</pre>
EOF
	return
}

cat << EOF
<html>
	<head>
		<title>$title</title>
	</head>
	<body>
		<h1>$title</h1>
		<p>$timestamp<ep>
		<pre>$(report_disk_space)</pre>
	</body>
</html>
EOF

