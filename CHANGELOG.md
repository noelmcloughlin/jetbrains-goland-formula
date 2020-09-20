# Changelog

# [1.1.0](https://github.com/saltstack-formulas/jetbrains-goland-formula/compare/v1.0.2...v1.1.0) (2020-09-20)


### Bug Fixes

* **macos:** fix clean state ([49b82ab](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/49b82ab725e988f1a70daae2097977512f053185))


### Features

* **windows:** basic windows support ([eab00d1](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/eab00d112f4699d69109139a39e22928aee4445b))

## [1.0.2](https://github.com/saltstack-formulas/jetbrains-goland-formula/compare/v1.0.1...v1.0.2) (2020-07-28)


### Bug Fixes

* **cmd.run:** wrap url in quotes (zsh) ([084c756](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/084c7561591034cecd2b9d2ee915a32f389f7719))
* **macos:** correct syntax ([bf9a285](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/bf9a2853242ad485c7c9833949c904a68895658c))
* **macos:** do not create shortcut file ([43f3738](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/43f373872ab5172cd73cf7889f578aa6f1d71e78))
* **macos:** do not create shortcut file ([1fb69e6](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/1fb69e6cc69d1ac2ad4b61b4700092d751ad0760))


### Code Refactoring

* **jetbrains:** align all jetbrains formulas ([182efff](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/182efff92cc48c7fe4919c01ef66ab3fe67ae9d7))


### Continuous Integration

* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([f1d3065](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/f1d30658861c3e641bc3647e57949983c9fefd99))


### Documentation

* **readme:** minor update ([d8ea7dc](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/d8ea7dc0b4ec55eb4aa7d457a2b00ae4dd203b53))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([7940f78](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/7940f78262847d61e9033df39ff3223a5842384d))

## [1.0.1](https://github.com/saltstack-formulas/jetbrains-goland-formula/compare/v1.0.0...v1.0.1) (2020-06-15)


### Bug Fixes

* **edition:** better edition jinja code ([c3460f5](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/c3460f5be980a9944a858e0e6a4f318d999899f6))


### Continuous Integration

* **kitchen+travis:** add new platforms [skip ci] ([c1d9d9c](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/c1d9d9ca3286ff2dea889aa0f70ccce9293c5da5))


### Documentation

* **readme:** impove formatting ([0537b25](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/0537b252503479f46a51267660f46a0c94dba680))

# [1.0.0](https://github.com/saltstack-formulas/jetbrains-goland-formula/compare/v0.2.0...v1.0.0) (2020-05-21)


### Bug Fixes

* **id:** rename conflicting id ([338535b](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/338535b45b2d7d36c03994d14b998533826c8b58))


### Continuous Integration

* **kitchen+travis:** adjust matrix to add `3000.3` ([8b041bb](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/8b041bb3d93931f6f1b7939b4ff108faa0c34632))


### Documentation

* **readme:** add depth one ([0db609f](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/0db609f9dcf929a918f5e3a7d30f7fbc73f11dca))


### Features

* **formula:** align to template-formula; add ci ([f4b426a](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/f4b426a0fae52e7485f0628102701548426f96b2))
* **formula:** align to template-formula; add ci ([baef66e](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/baef66e1c1087db5193afc92f67d79816b77a20e))
* **semantic-release:** standardise for this formula ([65be5ed](https://github.com/saltstack-formulas/jetbrains-goland-formula/commit/65be5ed11a847b87f14ec7a8ee3da4dc36649f5d))


### BREAKING CHANGES

* **formula:** Major refactor of formula to bring it in alignment with the
template-formula. As with all substantial changes, please ensure your
existing configurations work in the ways you expect from this formula.
