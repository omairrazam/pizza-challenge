# README

This README would normally document whatever steps and versions are necessary to get the
application up and running.


>Project is run and tested on macOS Ventura - Version 13.4.1

> As an addon, I added github actions which check linter and specs

> As an addon, I also added semantic-release for automatic version following semantic release

* Ruby version

    `3.1.2`

* Rails version

    `7.0.4`

* System dependencies
    
    1. postgres 9.6 `https://postgresapp.com/downloads.html`
    2. chromedriver for tests `brew install cask chromedriver` - need to find respective command for ubuntu
    3. if chromedriver is already installed then you might get old version error, in that case please reinstall `brew uninstall chromedriver` and then repeat step 2.
    
* System Setup (installing dependencies + database setup + migration + seeds)

    `bin/setup`

* Run application

    `bin/dev`

* Visit

    `http://localhost:3000/orders`
    
* How to run the test suite

    `rspec`

> There is still a chance that some package might be missing as already installed package on my machine, need to move to docker to avoid project setup issues

> if you face any issue then please raise an issue or email me at `omairr.azam@gmail.com`





