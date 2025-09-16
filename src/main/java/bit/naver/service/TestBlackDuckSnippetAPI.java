package bit.naver.service;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class TestBlackDuckSnippetAPI {
    // CVE-2015-7450

    /**
     * 공급망 보안 테스트 용: Apache Commons Collections 3.2.1의 InvokerTransformer 일부
     * 이 코드는 심각한 원격 코드 실행(RCE)으로 이어질 수 있는 역직렬화 취약점(CVE-2015-7450)의 일부입니다.
     * Black Duck과 같은 스니펫 스캔 도구가 이 코드 조각을 탐지하는지 테스트하기 위해 추가되었습니다.
     */
    public static class InvokerTransformer implements Serializable {
        private static final long serialVersionUID = -8653385846894547888L;
        private final String iMethodName;
        private final Class[] iParamTypes;
        private final Object[] iArgs;

        public InvokerTransformer(String methodName, Class[] paramTypes, Object[] args) {
            super();
            iMethodName = methodName;
            iParamTypes = paramTypes;
            iArgs = args;
        }

        public Object transform(Object input) {
            if (input == null) {
                return null;
            }
            try {
                Class cls = input.getClass();
                Method method = cls.getMethod(iMethodName, iParamTypes);
                return method.invoke(input, iArgs);
            } catch (NoSuchMethodException ex) {
                throw new RuntimeException("InvokerTransformer: The method '" + iMethodName + "' on '" + input.getClass() + "' does not exist");
            } catch (IllegalAccessException | InvocationTargetException ex) {
                throw new RuntimeException("InvokerTransformer: The method '" + iMethodName + "' on '" + input.getClass() + "' cannot be invoked", ex);
            }
        }
    }

    /**
     * 공급망 보안 테스트 용: Apache Commons Collections 3.2.1의 LazyMap 일부
     * 이 코드는 InvokerTransformer와 함께 사용되어 원격 코드 실행(RCE) 취약점(CVE-2015-7450)을 유발할 수 있습니다.
     * 스니펫 스캔 API의 최소 글자 수(300자) 요구사항을 만족시키기 위해 추가되었습니다.
     */
    public static abstract class AbstractMapDecorator implements java.util.Map, Serializable {
        private static final long serialVersionUID = -256220736379L;
        protected java.util.Map map;

        public AbstractMapDecorator(java.util.Map map) {
            if (map == null) {
                throw new IllegalArgumentException("Map must not be null.");
            }
            this.map = map;
        }

        public java.util.Collection values() {
            return this.map.values();
        }
    }

    public interface Transformer {
        Object transform(Object input);
    }

    public static class LazyMap extends AbstractMapDecorator {
        private static final long serialVersionUID = 7990956402564206760L;
        protected final Transformer factory;

        public static java.util.Map decorate(java.util.Map map, Transformer factory) {
            return new LazyMap(map, factory);
        }

        protected LazyMap(java.util.Map map, Transformer factory) {
            super(map);
            if (factory == null) {
                throw new IllegalArgumentException("Factory must not be null");
            }
            this.factory = factory;
        }

        public Object get(Object key) {
            if (!super.map.containsKey(key)) {
                super.map.put(key, this.factory.transform(key));
            }
            return super.map.get(key);
        }
    }

    /**
     * 공급망 보안 테스트 용: Apache Commons Collections 3.2.1의 ChainedTransformer 일부
     * 이 코드는 여러 Transformer를 연결하여 순차적으로 실행하며, 역직렬화 취약점(CVE-2015-7450) 공격에 사용될 수 있습니다.
     * 스니펫 스캔 API의 최소 글자 수(300자) 요구사항을 만족시키기 위해 추가되었습니다.
     */
    public static class ChainedTransformer implements Transformer, Serializable {
        private static final long serialVersionUID = 351494127533709113L;
        private final Transformer[] iTransformers;

        public ChainedTransformer(Transformer[] transformers) {
            super();
            iTransformers = transformers;
        }

        public Object transform(Object object) {
            for (int i = 0; i < iTransformers.length; i++) {
                object = iTransformers[i].transform(object);
            }
            return object;
        }
    }
}
