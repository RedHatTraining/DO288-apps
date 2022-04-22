package com.redhat.training.openshift.hello;

import io.quarkus.test.junit.NativeImageTest;

@NativeImageTest
public class NativeHelloResourceIT extends HelloResourceTest {

    // Execute the same tests but in native mode.
}