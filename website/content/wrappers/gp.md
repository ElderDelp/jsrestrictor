Title: gp
Filename: ../common/wrappingS-GP.js


navigator.getGamepads() allows any page script to learn the gampepads
connected to the computer if the feature is not blocked by the
Feature-Policy.

U. Iqbal, S. Englehardt and Z. Shafiq, "Fingerprinting the
Fingerprinters: Learning to Detect Browser Fingerprinting Behaviors,"
in 2021 2021 IEEE Symposium on Security and Privacy (SP), San Francisco,
CA, US, 2021 pp. 283-301 observed
(https://github.com/uiowa-irl/FP-Inspector/blob/master/Data/potential_fingerprinting_APIs.md)
that the interface is used in the wild to fingerprint users. As it is
likely that only a minority of users have a gamepad connected and the API
provides additional information on the HW, it is likely that users with
a gamepad connected are easily fingerprintable.

As we expect that the majority of the users does not have a gamepad
connected, we provide only a single mitigation - the wrapped APIs returns
an empty list.

\bug The standard provides an event *gamepadconnected* and
*gamepaddisconnected* that fires at least on the window object. We do not
mitigate the event to fire and consequently, it is possible that an
adversary can learn that a gamepad was (dis)connected but there was no
change in the result of the navigator.getGamepads() API.

The gamepad representing object carries a timestamp of the last change of
the gamepad. As we allow wrapping of several ways to obtain timestamps,
we need to provide the same precision for the Gamepad object.

