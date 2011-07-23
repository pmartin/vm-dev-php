#!/bin/bash

sudo apt-get -y install php5 php5-cli php5-curl php5-dev php5-gd php5-geoip php5-imagick php5-imap php5-intl php5-ldap php5-mcrypt php5-memcache php5-mysql php5-pgsql php5-sqlite php5-suhosin php5-tidy php5-xmlrpc php5-xsl libapache2-svn php-pear

sudo aptitude clean

# Timezone par défaut :
sudo sed -i -e 's/^;date.timezone =$/date.timezone = Europe\/Paris/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^;date.timezone =$/date.timezone = Europe\/Paris/' /etc/php5/cli/php.ini

# Quelques paramètres de conf qui ne me conviennent pas, pour une machine de développement / test
sudo sed -i -e 's/^short_open_tag = On$/short_open_tag = Off/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^;realpath_cache_size = 16k$/realpath_cache_size = 16k/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^;realpath_cache_ttl = 120$/realpath_cache_ttl = 120/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^max_execution_time = 30$/max_execution_time = 60/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^error_reporting = E_ALL & ~E_DEPRECATED$/error_reporting = E_ALL \& E_STRICT/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^display_errors = Off$/display_errors = On/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^track_errors = Off$/track_errors = On/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^html_errors = Off$/html_errors = On/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^upload_max_filesize = 2M$/upload_max_filesize = 5M/' /etc/php5/apache2/php.ini
sudo sed -i -e 's/^session.gc_maxlifetime = 1440$/session.gc_maxlifetime = 14400/' /etc/php5/apache2/php.ini


# Même chose, dans la conf CLI
sudo sed -i -e 's/^short_open_tag = On$/short_open_tag = Off/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^;realpath_cache_size = 16k$/realpath_cache_size = 16k/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^;realpath_cache_ttl = 120$/realpath_cache_ttl = 120/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^max_execution_time = 30$/max_execution_time = 60/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^error_reporting = E_ALL & ~E_DEPRECATED$/error_reporting = E_ALL \& E_STRICT/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^display_errors = Off$/display_errors = On/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^track_errors = Off$/track_errors = On/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^html_errors = Off$/html_errors = On/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^upload_max_filesize = 2M$/upload_max_filesize = 5M/' /etc/php5/cli/php.ini
sudo sed -i -e 's/^session.gc_maxlifetime = 1440$/session.gc_maxlifetime = 14400/' /etc/php5/cli/php.ini


# Installation de quelques extension via PECL
# => Téléchargement de la dernière version des sources + compilation
# Objectif : être sûr d'avoir une version à jour, pour des extensions qui sont mises à jour potentiellement 
#            plus souvent sur pecl que dans les repositories de la distribution
# (Et pour ces extensions, on veut une version récente / à jour, ne serait-ce que pour les corrections de bugs éventuels)

sudo pecl install xdebug

sudo sh -c "cat > /etc/php5/conf.d/xdebug.ini" <<EOF
zend_extension=/usr/lib/php5/20090626/xdebug.so

xdebug.default_enable = 1
xdebug.overload_var_dump = 1
xdebug.collect_includes = 1
xdebug.collect_params = 2
xdebug.collect_vars = 1
xdebug.show_exception_trace = 0
xdebug.show_mem_delta = 1
xdebug.max_nesting_level = 256
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 2048
xdebug.var_display_max_depth = 8
xdebug.auto_trace = 0
xdebug.profiler_enable = 0
xdebug.profiler_enable_trigger = 1
xdebug.profiler_append = 0
xdebug.profiler_output_dir = /tmp
xdebug.profiler_output_name = cachegrind.out.%t
EOF


sudo sh -c 'printf "\n" |pecl install apc'

sudo sh -c "cat > /etc/php5/conf.d/apc.ini" <<EOF
extension=apc.so

apc.enabled = 1
apc.ttl = 3600
apc.file_update_protection = 2
apc.stat = 1
apc.shm_size = 128
apc.shm_segments = 1
apc.user_entries_hint = 9000
apc.num_files_hint = 1024
apc.include_once_override = 1
apc.write_lock = 1
apc.localcache = 1
apc.localcache.size = 128
EOF




# Installation et configuration XHProf

sudo pecl install xhprof

sudo mkdir /tmp/xhprof
sudo chmod o+w /tmp/xhprof

sudo sh -c "cat > /etc/php5/conf.d/xhprof.ini" <<EOF
extension=xhprof.so
xhprof.output_dir="/tmp/xhprof"
EOF


sudo apt-get -y install graphviz
sudo apt-get clean

[ ! -d www ] && mkdir -f ${INSTALL_USERHOME}/www
mkdir ${INSTALL_USERHOME}/www/xhprof

xhprof_tgz=`ls /tmp/pear/download/xhprof-*`
cp ${xhprof_tgz} ${INSTALL_USERHOME}/www/xhprof/

xhprof_tgz_home=`ls ${INSTALL_USERHOME}/www/xhprof/xhprof*.tgz`
tar -xvf ${xhprof_tgz_home}
rm ${xhprof_tgz_home}
rm ${INSTALL_USERHOME}/www/xhprof/package.xml

xhprof_dir=${INSTALL_USERHOME}/www/xhprof/`ls ${INSTALL_USERHOME}/www/xhprof/ | grep 'xhprof-'`
cp -R ${xhprof_dir}/xhprof_html ${INSTALL_USERHOME}/www/xhprof/
cp -R ${xhprof_dir}/xhprof_lib ${INSTALL_USERHOME}/www/xhprof/
rm -R ${xhprof_dir} 


cat > ${INSTALL_USERHOME}/www/xhprof/header.php <<EOF
<?php
if (
    (
        (isset(\$_GET['XHPROF']) && \$_GET['XHPROF'])
        || (isset(\$_POST['XHPROF']) && \$_POST['XHPROF'])
        || (isset(\$_COOKIE['XHPROF']) && \$_COOKIE['XHPROF'])
    )
    && extension_loaded('xhprof')) {
    require_once 'xhprof_lib/utils/xhprof_lib.php';
    require_once 'xhprof_lib/utils/xhprof_runs.php';
    xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);
}
EOF

cat > ${INSTALL_USERHOME}/www/xhprof/footer.php <<EOF
<?php
if (
    (
        (isset(\$_GET['XHPROF']) && \$_GET['XHPROF'])
        || (isset(\$_POST['XHPROF']) && \$_POST['XHPROF'])
        || (isset(\$_COOKIE['XHPROF']) && \$_COOKIE['XHPROF'])
    )
    && extension_loaded('xhprof')) {
    \$profiler_namespace = 'myapp';  // namespace for your application
    \$xhprof_data = xhprof_disable();
    \$xhprof_runs = new XHProfRuns_Default();
    \$run_id = \$xhprof_runs->save_run(\$xhprof_data, \$profiler_namespace);
 
    // url to the XHProf UI libraries (change the host name and path)
    \$profiler_url = sprintf('http://%s/xhprof/xhprof_html/index.php?run=%s&source=%s', \$_SERVER['HTTP_HOST'], \$run_id, \$profiler_namespace);
    echo '<a href="'. \$profiler_url .'" target="_blank">Profiler output</a>';
}
EOF

cat >> ${INSTALL_USERHOME}/www/.htaccess <<EOF

php_value auto_prepend_file ${INSTALL_USERHOME}/www/xhprof/header.php
php_value auto_append_file ${INSTALL_USERHOME}/www/xhprof/footer.php

EOF







# Mise à jour des extensions PEAR déjà installées
sudo pear upgrade-all
sudo pear config-set auto_discover 1

# Installation de quelques extensions supplémentaires (pas forcément toujours utilisées, mais suffisament "souvent" pour que je les installe "par défaut")
sudo pear config-set preferred_state beta
sudo pear install --alldeps PHP_CodeSniffer PhpDocumentor php_CompatInfo Log Text_Diff HTML_QuickForm2 Image_GraphViz MDB2 Mail_Mime PHP_Beautifier-beta SOAP XML_Beautifier XML_RPC Structures_Graph components.ez.no/Graph VersionControl_SVN-alpha Horde_Text_Diff XML_RPC2 VersionControl_Git-alpha

# PHPUnit
sudo pear channel-discover pear.phpunit.de
sudo pear install --alldeps phpunit/PHPUnit

# Phing
sudo pear channel-discover pear.phing.info
sudo pear install --alldeps phing/phing

# DocBlox (en alternative plus récente (et compatible PHP 5.3) à PhpDocumentor)
sudo pear channel-discover pear.docblox-project.org
sudo pear install --alldeps docblox/DocBlox




