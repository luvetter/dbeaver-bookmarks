# dbeaver_bookmarks

Erzeugt eine Liste von Lesezeichen für DBeaver.

## Getting Started

Führe `flutter pub run build_runner build` aus, um die generierten Dateien zu erstellen.

## Milestones

### Prototype

- [x] Basic UI
- [x] Add persistence for projects
- [x] drop projects as unique objects; use a string property on connection configuration
- [x] Add localization
- [x] Add single connection configuration to project
- [x] Add multiple connection configuration to project
- [x] Add single connection to connection configuration
- [x] Add multiple connections to connection configuration
- [ ] Fill Connection with data
- [ ] Rework model
- [ ] generate dbeaver json from connection configuration
- [ ] add better error handling
- [ ] add tests
- [ ] add documentation

### Expand feature

- [ ] remember dbeaver workspace / general settings persistence
- [ ] Add templates for predefined variable-set usable in connections
- [ ] Add templates for list of same variable-set with different values. (results in multiple connections during dbeaver json generation)
- [ ] Add json-file as source for a template (single / multiple sets)
- [ ] Add json-http-response as source for a template (single / multiple sets)
- [ ] Export & Import / Backup & Restore of whole workspace
- [ ] Export & Import of single project / connection configuration (missing template?)
- [ ] Export & Import of single template
- [ ] make it pretty