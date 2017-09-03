dnstouch
========

An alternative to ndu's 'dnstouch' binary. This script is inspired by
tombart_'s answer on stackexchange_. It updates a zone file's serial number by
adding ``+1``.

For ``dnstouch.sh`` to work you'll need at least ``bash`` 4.2.


first time usage
----------------

To find the serial number ``$needle`` matches the line's comment
(see example zone file ``my.zone``). To make sure you won't experience
unnecessary errors, you'll have to configure ``$needle`` to your needs
and set ``$needleSet`` inline to anything but ``false``.

example
-------

::

  # dnstouch.sh /etc/bind/zones/my.zone
  my.zone:              2017082500; serial


.. "all the links"-section
.. _tombart: www.stackoverflow.com/users/34514/tombart
.. _stackexchange: unix.stackexchange.com/q/197988
