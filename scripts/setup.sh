#!/bin/bash
read -p "Copy UNIX path to DS-Wizard-Client folder on your host system: " wpath
rm -r $HOME/DS-Wizard-Client/engine-wizard
rm -r $HOME/DS-Wizard-Client/dsw-deployment-example/assets
ln -s $wpath/engine-wizard $HOME/DS-Wizard-Client/engine-wizard
ln -s $wpath/dsw-deployment-example/assets $HOME/DS-Wizard-Client/dsw-deployment-example/assets
