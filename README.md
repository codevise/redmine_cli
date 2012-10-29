# Redmine CLI
A simple command line client for the redmine project managment tool (see http://redmine.org/ ).

## Installation
Clone the repository and simply add the `bin` directory to your PATH.

Redmine CLI uses git config as configuration backend. You have to set some git config variables.

    git config --global redmine.apikey 2d2972329e271a2a1c6d4322e3727001 # Your redmine API key
    git config --global redmine.url http://redmine.your-domain.org # URL of your redmine installation
    git config redmine.project my-project # ID of your project

## Usage

### Timevise

Display current sign in status:

    $ redmine time current

Sign out:

    $ redmine time out

### Issues

List open issues of current project:

    $ redmine list open

### Commiting

Commit with ref to issue whose subject matches <term>:

    $ redmine commit [refs|closes|fixes] <term> -m "<msg>"

Commit with ref to issue you are currently signed in for:

    $ redmine commit [refs|closes|fixes] -m "<msg>"

### More Help

Use the built in documentation mechanism, i.e.

    $ redmine help list

and

    $ redmine list help open

## License

See LICENSE.