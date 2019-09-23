# GoContacts
simple iOS cloud contacts app in swift.

1. Used Master detail template and following MVVM pattern architecture
2. Contact list Controller and detail controller takes care of contact list
3. Pattern implemented
  model <- viewmodel  <- Controller -> viewcontroller -> view

4. App works on all devices (iphone, ipad) for all orientation.
5. Network call are handled through NetworkManager

Things not done:
1. detail page scrolling when editting text fields and keyboard is up
2. Delete button in detail page not implemented for contact as mentioned in sketch document. Wasn't mentioned in problem statement, so left it.
