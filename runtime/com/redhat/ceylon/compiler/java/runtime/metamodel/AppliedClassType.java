package com.redhat.ceylon.compiler.java.runtime.metamodel;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Constructor;
import java.util.LinkedList;
import java.util.List;

import ceylon.language.Callable;
import ceylon.language.Sequential;
import ceylon.language.metamodel.AppliedClassType$impl;
import ceylon.language.metamodel.Class;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;
import com.redhat.ceylon.compiler.java.metadata.Variance;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;
import com.redhat.ceylon.compiler.typechecker.model.Parameter;
import com.redhat.ceylon.compiler.typechecker.model.ProducedType;

@Ceylon(major = 4)
@com.redhat.ceylon.compiler.java.metadata.Class
@TypeParameters({
    @TypeParameter(value = "Type", variance = Variance.OUT),
    @TypeParameter(value = "Arguments", variance = Variance.IN, satisfies = "ceylon.language::Sequential<ceylon.language::Anything>"),
    })
public class AppliedClassType<Type, Arguments extends Sequential<? extends Object>> 
    extends AppliedClassOrInterfaceType<Type>
    implements ceylon.language.metamodel.AppliedClassType<Type, Arguments>, Callable<Type> {

    private TypeDescriptor $reifiedArguments;
    private TypeDescriptor $reifiedType;
    private MethodHandle constructor;
    
    public AppliedClassType(com.redhat.ceylon.compiler.typechecker.model.ProducedType producedType) {
        super(producedType);
    }

    @Override
    @Ignore
    public AppliedClassType$impl<Type, Arguments> $ceylon$language$metamodel$AppliedClassType$impl() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    @TypeInfo("ceylon.language.metamodel::Class")
    public ceylon.language.metamodel.Class getDeclaration() {
        return (Class) super.getDeclaration();
    }

    @Override
    protected void init() {
        super.init();
        com.redhat.ceylon.compiler.typechecker.model.Class decl = (com.redhat.ceylon.compiler.typechecker.model.Class) producedType.getDeclaration();
        List<com.redhat.ceylon.compiler.typechecker.model.ProducedType> elemTypes = new LinkedList<com.redhat.ceylon.compiler.typechecker.model.ProducedType>();
        for(Parameter param : decl.getParameterList().getParameters()){
            com.redhat.ceylon.compiler.typechecker.model.ProducedType paramType = param.getType().substitute(producedType.getTypeArguments());
            elemTypes.add(paramType);
        }
        // FIXME: last three params
        com.redhat.ceylon.compiler.typechecker.model.ProducedType tupleType = decl.getUnit().getTupleType(elemTypes, false, false, -1);
        this.$reifiedArguments = Metamodel.getTypeDescriptorForProducedType(tupleType);
        this.$reifiedType = Metamodel.getTypeDescriptorForProducedType(producedType);
        // FIXME: delay constructor setup for when we actually use it?
        // FIXME: finding the right MethodHandle for the constructor could actually be done in the Class declaration
        java.lang.Class<?> javaClass = Metamodel.getJavaClass(declaration.declaration);
        // FIXME: deal with Java classes
        // FIXME: faster lookup with types? but then we have to deal with erasure and stuff
        Constructor<?> found = null;
        for(Constructor<?> constr : javaClass.getDeclaredConstructors()){
            if(constr.isAnnotationPresent(Ignore.class))
                continue;
            // FIXME: deal with private stuff?
            if(found != null){
                throw new RuntimeException("More than one constructor found for: "+javaClass+", 1st: "+found+", 2nd: "+constr);
            }
            found = constr;
        }
        if(found != null){
            try {
                constructor = MethodHandles.lookup().unreflectConstructor(found);
            } catch (IllegalAccessException e) {
                throw new RuntimeException("Problem getting a MH for constructor for: "+javaClass, e);
            }
            // we need to cast to Object because this is what comes out when calling it in $call
            java.lang.Class<?>[] parameterTypes = found.getParameterTypes();
            constructor = constructor.asType(MethodType.methodType(Object.class, parameterTypes));
            int typeParametersCount = javaClass.getTypeParameters().length;
            // insert any required type descriptors
            // FIXME: only if it's expecting them!
            if(typeParametersCount != 0){
                List<ProducedType> typeArguments = producedType.getTypeArgumentList();
                Object[] typeDescriptors = new TypeDescriptor[typeArguments.size()];
                for(int i=0;i<typeDescriptors.length;i++){
                    typeDescriptors[i] = Metamodel.getTypeDescriptorForProducedType(typeArguments.get(i));
                }
                constructor = MethodHandles.insertArguments(constructor, 0, typeDescriptors);
            }
            // now convert all arguments (we may need to unbox)
            MethodHandle[] filters = new MethodHandle[parameterTypes.length - typeParametersCount];
            try {
                for(int i=0;i<filters.length;i++){
                    java.lang.Class<?> paramType = parameterTypes[i+typeParametersCount];
                    // FIXME: more boxing
                    if(paramType == java.lang.String.class){
                        // ((ceylon.language.String)obj).toString()
                        MethodHandle toString = MethodHandles.lookup().findVirtual(ceylon.language.String.class, "toString", 
                                                                                   MethodType.methodType(java.lang.String.class));
                        filters[i] = toString.asType(MethodType.methodType(java.lang.String.class, java.lang.Object.class));
                    }else if(paramType == long.class){
                        // ((ceylon.language.Integer)obj).longValue()
                        MethodHandle toLong = MethodHandles.lookup().findVirtual(ceylon.language.Integer.class, "longValue", 
                                                                                 MethodType.methodType(long.class));
                        filters[i] = toLong.asType(MethodType.methodType(long.class, java.lang.Object.class));
                    }
                }
            } catch (NoSuchMethodException | IllegalAccessException e) {
                throw new RuntimeException("Failed to filter parameter", e);
            }
            constructor = MethodHandles.filterArguments(constructor, 0, filters);
        }
        
    }

    @Override
    public Type $call() {
        if(constructor == null)
            throw new RuntimeException("No constructor found for: "+declaration.getName());
        try {
            return (Type)constructor.invokeExact();
        } catch (Throwable e) {
            throw new RuntimeException("Failed to invoke constructor for "+declaration.getName(), e);
        }
    }

    @Override
    public Type $call(Object arg0) {
        if(constructor == null)
            throw new RuntimeException("No constructor found for: "+declaration.getName());
        try {
            return (Type)constructor.invokeExact(arg0);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to invoke constructor for "+declaration.getName(), e);
        }
    }

    @Override
    public Type $call(Object arg0, Object arg1) {
        if(constructor == null)
            throw new RuntimeException("No constructor found for: "+declaration.getName());
        try {
            return (Type)constructor.invokeExact(arg0, arg1);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to invoke constructor for "+declaration.getName(), e);
        }
    }

    @Override
    public Type $call(Object arg0, Object arg1, Object arg2) {
        if(constructor == null)
            throw new RuntimeException("No constructor found for: "+declaration.getName());
        try {
            return (Type)constructor.invokeExact(arg0, arg1, arg2);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to invoke constructor for "+declaration.getName(), e);
        }
    }

    @Override
    public Type $call(Object... args) {
        if(constructor == null)
            throw new RuntimeException("No constructor found for: "+declaration.getName());
        return null;
    }
    
    @Override
    public TypeDescriptor $getType() {
        checkInit();
        return TypeDescriptor.klass(AppliedClassType.class, $reifiedType, $reifiedArguments);
    }
}
