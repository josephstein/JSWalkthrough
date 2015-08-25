# JSWalkthrough
JSWalkthrough provides a convenient way to present a walkthrough flow in your app. It is a subclass of `UIViewController` that accepts an array of storyboard ID's and will stitch it together into a paged scrollview. 

## Demo
![alt text](https://github.com/josephstein/JSWalkthrough/blob/master/demo.gif "Demo")

## Configurations
It's currently set up to have one `UIButton` that changes it's title depending on whether it's displaying the last page or not. Both the **Skip** and **Done** button titles are configurable. If the **Skip** button title is `nil` or empty, then the button will be hidden except for the last screen.

## Installation

### CocoaPods
`TODO`

### Manual

Simply add `JSWalkthroughViewController.swift` to your project

## How to Use

1. Add `JSWalkthroughViewController.swift` to your project
2. Create a new Storyboard
3. Drag a `UIViewController`to the storyboard
  * Open the `Attributes Inspector` tab and select the `Is Initial View Controller` checkbox
  * Apply the following `UIKit` elements to the view and assign it their respective `IBOutlet` names:

    | Object          | IBOutlet      |
    | --------------- |:-------------:|
    | `UIScrollView`  | `scrollView`  |
    | `UIPageControl` | `pageControl` |
    | `UIButton`      | `actionButtonin`|
  * Apply a width constraint to `actionButton` and assign the constraint the `IBOutlet` named `actionButtonWidthConstraint`
4. Drag out at least 3 new `UIVIewController`'s to the storyboard, design it, and give them a `Storyboard ID` identifier (located in the `Identity Inspector` tab)
5. Where you're ready to present the walkthrough, instantiate the class and set the following required properties:
  * `storyboardIdentifiers` (An array of the storyboard identifiers you set in `Step 4`)
  * `doneButtonTitle`
  * `skipButtonTitle`
  * `dismissBlock`
  
## Creator

* [josephstein.com](http://www.josephstein.com)
* [@josephstein](http://www.twitter.com/josephstein)

## License

```
The MIT License (MIT)

Copyright (c) 2015 Joseph Stein

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
