# Table Tennis Scoring Board

![This is an image](https://github.com/etnt/tt/blob/main/priv/docroot/images/logo.png)

This is an old system that I managed to salvaged from an old Bitbucket archive.
It made use of Webmachine for serving the HTTP interface and CouchDB for storing
the Table Tennis scoring data + some nifty Javascript to populate the frontend.

## Environment setup

In the tt directory:

    make init

You also need to have CouchDB up and running in your machine.

To compile the source code of the tt application:

    make compile


## CouchDB objects

    scores: nick x scores
    matches: winner x looser x figures x gsec

