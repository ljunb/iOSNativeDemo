/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';

const router = {
  'PageA': require('./page/PageA').default,
  'PageB': require('./page/PageB').default,
};

export default class App extends Component {
  render() {
    const routerKey = this.props[PAGE_NAME];
    const Component = router[routerKey];
    return <Component {...this.props}/>;
  }
}