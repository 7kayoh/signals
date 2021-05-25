# Signals
A simple and lightweight signals & slots implementation, works with Vanilla Lua and Luau (Roblox).

I created this module because I never liked the idea of using bindables (Roblox) for a UI framework, bindables deep copy the argument when sent, as a result, we can not do something such as `arg == original`, which may be troublesome when we want to verify integrity.

On the other hand, bindable is an instance, so you would be creating a lot of them in a single component (let's say a button component), which isn't really optimal in my opinion.