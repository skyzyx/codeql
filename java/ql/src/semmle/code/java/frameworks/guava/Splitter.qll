/**
 * Definitions for tracking taint steps through the methods of `com.google.common.base.Splitter`.
 */

import java
import semmle.code.java.dataflow.FlowSteps

/**
 * The class `com.google.common.base.Splitter`.
 */
class TypeGuavaSplitter extends Class {
  TypeGuavaSplitter() { this.hasQualifiedName("com.google.common.base", "Splitter") }
}

/**
 * The nested class `Splitter.MapSplitter`.
 */
class TypeGuavaMapSplitter extends NestedClass {
  TypeGuavaMapSplitter() {
    this.getEnclosingType() instanceof TypeGuavaSplitter and
    this.hasName("MapSplitter")
  }
}

/**
 * A method of `Splitter` or `MapSplitter` that splits its input string.
 */
private class GuavaSplitMethod extends TaintPreservingCallable {
  GuavaSplitMethod() {
    (
      this.getDeclaringType() instanceof TypeGuavaSplitter
      or
      this.getDeclaringType() instanceof TypeGuavaMapSplitter
    ) and
    // Iterable<String> split(CharSequence sequence)
    // List<String> splitToList(CharSequence sequence)
    // Stream<String> splitToStream(CharSequence sequence)
    // Map<String,String> split(CharSequence sequence) [on MapSplitter]
    this.hasName(["split", "splitToList", "splitToStream"])
  }

  override predicate returnsTaintFrom(int src) { src = 0 }
}
