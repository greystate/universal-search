# Universal Search

A single page with search forms for many of the sites I search.

Just being able to search IMDb without having to wade through a bunch of
"engaging content" first is worth every minute spent on refining this form!

**NOTE:** Some forms require an API key to work (but usually free to obtain).
Instead of saving these in the file I've implemented a crude facility to load
and save these, i.e. when you've entered the key in the form field(s), click the
_Save API keys_ button to put them into your browser's **Local Storage** (this
requires that you're running the page using either https:// or the file://
protocols). You should only need to save them once - after that you can just
load them whenever you need to call those specific services. Yes, I'll consider
auto-loading them at some point :)
