global.PAGE_NAME = 'pageName';

import { AppRegistry } from 'react-native';
import App from './App';

// 统一appKey方式
AppRegistry.registerComponent('iOSNativeDemo', () => App);

// 不同appKey方式
AppRegistry.registerComponent('PageC', () => require('./page/PageC').default);
AppRegistry.registerComponent('PageD', () => require('./page/PageD').default);
