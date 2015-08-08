/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

namespace democmds.core {

using System;
using System.Runtime.InteropServices;

class democmdsPINVOKE {

  protected class SWIGExceptionHelper {

    public delegate void ExceptionDelegate(string message);
    public delegate void ExceptionArgumentDelegate(string message, string paramName);

    static ExceptionDelegate applicationDelegate = new ExceptionDelegate(SetPendingApplicationException);
    static ExceptionDelegate arithmeticDelegate = new ExceptionDelegate(SetPendingArithmeticException);
    static ExceptionDelegate divideByZeroDelegate = new ExceptionDelegate(SetPendingDivideByZeroException);
    static ExceptionDelegate indexOutOfRangeDelegate = new ExceptionDelegate(SetPendingIndexOutOfRangeException);
    static ExceptionDelegate invalidCastDelegate = new ExceptionDelegate(SetPendingInvalidCastException);
    static ExceptionDelegate invalidOperationDelegate = new ExceptionDelegate(SetPendingInvalidOperationException);
    static ExceptionDelegate ioDelegate = new ExceptionDelegate(SetPendingIOException);
    static ExceptionDelegate nullReferenceDelegate = new ExceptionDelegate(SetPendingNullReferenceException);
    static ExceptionDelegate outOfMemoryDelegate = new ExceptionDelegate(SetPendingOutOfMemoryException);
    static ExceptionDelegate overflowDelegate = new ExceptionDelegate(SetPendingOverflowException);
    static ExceptionDelegate systemDelegate = new ExceptionDelegate(SetPendingSystemException);

    static ExceptionArgumentDelegate argumentDelegate = new ExceptionArgumentDelegate(SetPendingArgumentException);
    static ExceptionArgumentDelegate argumentNullDelegate = new ExceptionArgumentDelegate(SetPendingArgumentNullException);
    static ExceptionArgumentDelegate argumentOutOfRangeDelegate = new ExceptionArgumentDelegate(SetPendingArgumentOutOfRangeException);

    [DllImport("democmds", EntryPoint="SWIGRegisterExceptionCallbacks_democmds")]
    public static extern void SWIGRegisterExceptionCallbacks_democmds(
                                ExceptionDelegate applicationDelegate,
                                ExceptionDelegate arithmeticDelegate,
                                ExceptionDelegate divideByZeroDelegate, 
                                ExceptionDelegate indexOutOfRangeDelegate, 
                                ExceptionDelegate invalidCastDelegate,
                                ExceptionDelegate invalidOperationDelegate,
                                ExceptionDelegate ioDelegate,
                                ExceptionDelegate nullReferenceDelegate,
                                ExceptionDelegate outOfMemoryDelegate, 
                                ExceptionDelegate overflowDelegate, 
                                ExceptionDelegate systemExceptionDelegate);

    [DllImport("democmds", EntryPoint="SWIGRegisterExceptionArgumentCallbacks_democmds")]
    public static extern void SWIGRegisterExceptionCallbacksArgument_democmds(
                                ExceptionArgumentDelegate argumentDelegate,
                                ExceptionArgumentDelegate argumentNullDelegate,
                                ExceptionArgumentDelegate argumentOutOfRangeDelegate);

    static void SetPendingApplicationException(string message) {
      SWIGPendingException.Set(new System.ApplicationException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingArithmeticException(string message) {
      SWIGPendingException.Set(new System.ArithmeticException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingDivideByZeroException(string message) {
      SWIGPendingException.Set(new System.DivideByZeroException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingIndexOutOfRangeException(string message) {
      SWIGPendingException.Set(new System.IndexOutOfRangeException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingInvalidCastException(string message) {
      SWIGPendingException.Set(new System.InvalidCastException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingInvalidOperationException(string message) {
      SWIGPendingException.Set(new System.InvalidOperationException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingIOException(string message) {
      SWIGPendingException.Set(new System.IO.IOException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingNullReferenceException(string message) {
      SWIGPendingException.Set(new System.NullReferenceException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingOutOfMemoryException(string message) {
      SWIGPendingException.Set(new System.OutOfMemoryException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingOverflowException(string message) {
      SWIGPendingException.Set(new System.OverflowException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingSystemException(string message) {
      SWIGPendingException.Set(new System.SystemException(message, SWIGPendingException.Retrieve()));
    }

    static void SetPendingArgumentException(string message, string paramName) {
      SWIGPendingException.Set(new System.ArgumentException(message, paramName, SWIGPendingException.Retrieve()));
    }
    static void SetPendingArgumentNullException(string message, string paramName) {
      Exception e = SWIGPendingException.Retrieve();
      if (e != null) message = message + " Inner Exception: " + e.Message;
      SWIGPendingException.Set(new System.ArgumentNullException(paramName, message));
    }
    static void SetPendingArgumentOutOfRangeException(string message, string paramName) {
      Exception e = SWIGPendingException.Retrieve();
      if (e != null) message = message + " Inner Exception: " + e.Message;
      SWIGPendingException.Set(new System.ArgumentOutOfRangeException(paramName, message));
    }

    static SWIGExceptionHelper() {
      SWIGRegisterExceptionCallbacks_democmds(
                                applicationDelegate,
                                arithmeticDelegate,
                                divideByZeroDelegate,
                                indexOutOfRangeDelegate,
                                invalidCastDelegate,
                                invalidOperationDelegate,
                                ioDelegate,
                                nullReferenceDelegate,
                                outOfMemoryDelegate,
                                overflowDelegate,
                                systemDelegate);

      SWIGRegisterExceptionCallbacksArgument_democmds(
                                argumentDelegate,
                                argumentNullDelegate,
                                argumentOutOfRangeDelegate);
    }
  }

  protected static SWIGExceptionHelper swigExceptionHelper = new SWIGExceptionHelper();

  public class SWIGPendingException {
    [ThreadStatic]
    private static Exception pendingException = null;
    private static int numExceptionsPending = 0;

    public static bool Pending {
      get {
        bool pending = false;
        if (numExceptionsPending > 0)
          if (pendingException != null)
            pending = true;
        return pending;
      } 
    }

    public static void Set(Exception e) {
      if (pendingException != null)
        throw new ApplicationException("FATAL: An earlier pending exception from unmanaged code was missed and thus not thrown (" + pendingException.ToString() + ")", e);
      pendingException = e;
      lock(typeof(democmdsPINVOKE)) {
        numExceptionsPending++;
      }
    }

    public static Exception Retrieve() {
      Exception e = null;
      if (numExceptionsPending > 0) {
        if (pendingException != null) {
          e = pendingException;
          pendingException = null;
          lock(typeof(democmdsPINVOKE)) {
            numExceptionsPending--;
          }
        }
      }
      return e;
    }
  }


  protected class SWIGStringHelper {

    public delegate string SWIGStringDelegate(string message);
    static SWIGStringDelegate stringDelegate = new SWIGStringDelegate(CreateString);

    [DllImport("democmds", EntryPoint="SWIGRegisterStringCallback_democmds")]
    public static extern void SWIGRegisterStringCallback_democmds(SWIGStringDelegate stringDelegate);

    static string CreateString(string cString) {
      return cString;
    }

    static SWIGStringHelper() {
      SWIGRegisterStringCallback_democmds(stringDelegate);
    }
  }

  static protected SWIGStringHelper swigStringHelper = new SWIGStringHelper();


  static democmdsPINVOKE() {
  }


  [DllImport("democmds", EntryPoint="CSharp_delete_Floats")]
  public static extern void delete_Floats(HandleRef jarg1);

  [DllImport("democmds", EntryPoint="CSharp_new_Floats__SWIG_0")]
  public static extern IntPtr new_Floats__SWIG_0(int jarg1);

  [DllImport("democmds", EntryPoint="CSharp_new_Floats__SWIG_1")]
  public static extern IntPtr new_Floats__SWIG_1();

  [DllImport("democmds", EntryPoint="CSharp_Floats_setSize")]
  public static extern void Floats_setSize(HandleRef jarg1, int jarg2);

  [DllImport("democmds", EntryPoint="CSharp_new_Floats__SWIG_2")]
  public static extern IntPtr new_Floats__SWIG_2(float jarg1, float jarg2);

  [DllImport("democmds", EntryPoint="CSharp_new_Floats__SWIG_3")]
  public static extern IntPtr new_Floats__SWIG_3(float jarg1, float jarg2, float jarg3, float jarg4);

  [DllImport("democmds", EntryPoint="CSharp_Floats_count")]
  public static extern int Floats_count(HandleRef jarg1);

  [DllImport("democmds", EntryPoint="CSharp_Floats_get")]
  public static extern float Floats_get(HandleRef jarg1, int jarg2);

  [DllImport("democmds", EntryPoint="CSharp_Floats_set__SWIG_0")]
  public static extern void Floats_set__SWIG_0(HandleRef jarg1, int jarg2, float jarg3);

  [DllImport("democmds", EntryPoint="CSharp_Floats_set__SWIG_1")]
  public static extern void Floats_set__SWIG_1(HandleRef jarg1, int jarg2, float jarg3, float jarg4);

  [DllImport("democmds", EntryPoint="CSharp_delete_Chars")]
  public static extern void delete_Chars(HandleRef jarg1);

  [DllImport("democmds", EntryPoint="CSharp_new_Chars__SWIG_0")]
  public static extern IntPtr new_Chars__SWIG_0(int jarg1);

  [DllImport("democmds", EntryPoint="CSharp_new_Chars__SWIG_1")]
  public static extern IntPtr new_Chars__SWIG_1();

  [DllImport("democmds", EntryPoint="CSharp_Chars_setSize")]
  public static extern void Chars_setSize(HandleRef jarg1, int jarg2);

  [DllImport("democmds", EntryPoint="CSharp_new_Chars__SWIG_2")]
  public static extern IntPtr new_Chars__SWIG_2(char jarg1, char jarg2);

  [DllImport("democmds", EntryPoint="CSharp_new_Chars__SWIG_3")]
  public static extern IntPtr new_Chars__SWIG_3(char jarg1, char jarg2, char jarg3, char jarg4);

  [DllImport("democmds", EntryPoint="CSharp_Chars_count")]
  public static extern int Chars_count(HandleRef jarg1);

  [DllImport("democmds", EntryPoint="CSharp_Chars_get")]
  public static extern char Chars_get(HandleRef jarg1, int jarg2);

  [DllImport("democmds", EntryPoint="CSharp_Chars_set__SWIG_0")]
  public static extern void Chars_set__SWIG_0(HandleRef jarg1, int jarg2, char jarg3);

  [DllImport("democmds", EntryPoint="CSharp_Chars_set__SWIG_1")]
  public static extern void Chars_set__SWIG_1(HandleRef jarg1, int jarg2, char jarg3, char jarg4);

  [DllImport("democmds", EntryPoint="CSharp_DemoCmdsGate_registerCmds")]
  public static extern int DemoCmdsGate_registerCmds(int jarg1);

  [DllImport("democmds", EntryPoint="CSharp_DemoCmdsGate_getDimensions")]
  public static extern int DemoCmdsGate_getDimensions(int jarg1, HandleRef jarg2, HandleRef jarg3);

  [DllImport("democmds", EntryPoint="CSharp_new_DemoCmdsGate")]
  public static extern IntPtr new_DemoCmdsGate();

  [DllImport("democmds", EntryPoint="CSharp_delete_DemoCmdsGate")]
  public static extern void delete_DemoCmdsGate(HandleRef jarg1);
}

}