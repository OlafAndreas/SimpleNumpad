# SimpleNumpad

Renders a simple numpad view for the selected `UITextField` which replaces the native keyboard.

### Usage
It's important that the `UITextField` delegate `textFieldShouldBeginEditing` returns `false` to prevent the native keyboard from appearing.

```swift
func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

    NumberPadViewController.display(self, fromView: textField, value: value, onValueChanged: {
        newValue in
                
        textField.text = newValue
                
    }, passthroughViews:  nil}))

    return false
}

```

### Install using CocoaPods
```ruby
source 'git@github.com:OlafAndreas/SimpleNumpad.git'

platform :ios, '9.0'
use_frameworks!

target "MyTarget" do
    pod 'SimpleNumpad'
end
```
