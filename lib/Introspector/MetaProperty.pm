use strict;
use warnings;

#package java.beans.PropertyDescriptor
#package java.beans.BeanDescriptor
#package java.beans.FeatureDescriptor
#package java.beans.BeanInfo
#package java.beans.EventSetDescriptor
#package java.beans.MethodDescriptor
#package java.beans.ParameterDescriptor

#Class propertyType;
#ReadMethod-- RETURN

#Method readMethod;
getNAME  # VARIABLE
isNAME   # PREDICATE

#Method writeMethod;
setNAME

#boolean bound;
# does it have a PropertyChange?

#boolean constrained;
# can it be vetoed

#Class propertyEditorClass;
# targetType.getName "Editor"
# PropertyEditorManager
	##load(Boolean.TYPE, "BoolEditor");
	##load(Byte.TYPE, "ByteEditor");
	#load(???, "ColorEditor");
	##load(Double.TYPE, "DoubleEditor");
	##load(Float.TYPE, "FloatEditor");
	#load(???, "FontEditor");
	##load(Integer.TYPE, "IntEditor");
	##load(Long.TYPE ,"LongEditor");
	#load(????, "NumberEditor");
	##load(Short.TYPE, "ShortEditor");
	#load(????, "StringEditor");
#sun.beans.editors
#extends java.beans.PropertyEditorSupport {
#extends PropertySupport.ReadWrite {
#extends PropertyEditorSupport implements EnhancedPropertyEditor {
#public class PropertyEditorSupport implements PropertyEditor {
#public interface PropertyEditor {
#public class PropertyEditorManager {
# IndexedPropertyEditor
#public class PropertyDescriptor extends FeatureDescriptor {
#public class ClassEditor extends java.beans.PropertyEditorSupport {
#org.openide.explorer.propertysheet;
#org.openide.explorer.propertysheet.ExPropertyEditor;
#org.openide.explorer.propertysheet.editors.EnhancedPropertyEditor;
#org.netbeans.modules.beans;
#org.openide.explorer.view.BeanTreeView;
#org.netbeans.modules.beans.beaninfo;
#org.netbeans.beaninfo;
#org.netbeans.core;
#org.netbeans.core.execution;
#org.netbeans.core.windows.nodes;
#org.netbeans.core.windows.toolbars;
#org.netbeans.modules.debugger.delegator;
#org.netbeans.modules.debugger.multisession;
#org.netbeans.modules.editor.options;
#org.netbeans.modules.extbrowser;
#org.netbeans.modules.form;
#org.openide.explorer.view;
#org.netbeans.modules.rmi.activation;
