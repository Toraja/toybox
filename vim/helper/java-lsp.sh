#!/usr/bin/env bash

lsp_home="$HOME/garage/tools/jdt-language-server"
JAR="$lsp_home/lsp/plugins/org.eclipse.equinox.launcher_*.jar"
java \
	-Declipse.application=org.eclipse.jdt.ls.core.id1 \
	-Dosgi.bundles.defaultStartLevel=4 \
	-Declipse.product=org.eclipse.jdt.ls.core.product \
	-Dlog.level=ALL \
	-Xmx1G \
	-jar $(echo "$JAR") \
	-configuration "$lsp_home/lsp/config_linux/" \
	-data "$lsp_home/workspace/" \
	--add-modules=ALL-SYSTEM \
	--add-opens java.base/java.util=ALL-UNNAMED \
	--add-opens java.base/java.lang=ALL-UNNAMED \
