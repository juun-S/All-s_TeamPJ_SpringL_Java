package bit.naver.service;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class TestBlackDuckSnippetAPI {

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
}
